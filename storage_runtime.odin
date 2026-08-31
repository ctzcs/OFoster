package foster_framework

import "base:runtime"
import "core:fmt"
import os "core:os"
import filepath "core:path/filepath"
import "core:strings"
import SDL "vendor:sdl3"

DialogResult :: struct {
	Files: []string,
	Cancelled: bool,
}

DialogCallback :: #type proc(result: DialogResult)
DialogCallbackSingleFile :: #type proc(file: string)

DialogFilter :: struct {
	Name: string,
	Pattern: string,
}

StorageContainer :: struct {
	Root: string,
	Writable: bool,
}

Storage :: StorageContainer

FileSystem :: struct {
	App: ^App,
}

storage_join_path :: proc(container: ^StorageContainer, path: string) -> string {
	if container.Root == "" {
		cleaned, _ := filepath.clean(path, context.temp_allocator)
		return cleaned
	}
	if strings.trim_space(path) == "" {
		return container.Root
	}
	joined, _ := filepath.join({container.Root, path}, context.temp_allocator)
	cleaned, _ := filepath.clean(joined, context.temp_allocator)
	return cleaned
}

storage_exists :: proc(container: ^StorageContainer, path: string) -> bool {
	return os.exists(storage_join_path(container, path))
}

storage_file_exists :: proc(container: ^StorageContainer, path: string) -> bool {
	full := storage_join_path(container, path)
	return os.exists(full) && !os.is_directory(full)
}

storage_directory_exists :: proc(container: ^StorageContainer, path: string) -> bool {
	return os.is_directory(storage_join_path(container, path))
}

storage_enumerate_directory :: proc(container: ^StorageContainer, path: string, allocator := context.allocator) -> []string {
	full := storage_join_path(container, path)
	infos, err := os.read_all_directory_by_path(full, allocator)
	if err != nil {
		return nil
	}
	defer os.file_info_slice_delete(infos, allocator)

	result := make([dynamic]string, 0, len(infos), allocator)
	for info in infos {
		name, clone_err := strings.clone(info.name, allocator)
		if clone_err != nil {
			continue
		}
		append(&result, name)
	}
	return result[:]
}

storage_create_directory :: proc(container: ^StorageContainer, path: string) -> bool {
	if !container.Writable {
		return false
	}
	return os.make_directory_all(storage_join_path(container, path)) == nil
}

storage_remove :: proc(container: ^StorageContainer, path: string) -> bool {
	if !container.Writable {
		return false
	}
	full := storage_join_path(container, path)
	if os.is_directory(full) {
		return os.remove_all(full) == nil
	}
	return os.remove(full) == nil
}

storage_read_all_bytes :: proc(container: ^StorageContainer, path: string, allocator := context.allocator) -> []byte {
	data, err := os.read_entire_file(storage_join_path(container, path), allocator)
	if err != nil {
		return nil
	}
	return data
}

storage_read_all_text :: proc(container: ^StorageContainer, path: string, allocator := context.allocator) -> string {
	data := storage_read_all_bytes(container, path, allocator)
	if len(data) == 0 {
		return ""
	}
	return string(data)
}

storage_write_all_bytes :: proc(container: ^StorageContainer, path: string, data: []byte) -> bool {
	if !container.Writable {
		return false
	}
	full := storage_join_path(container, path)
	parent, _ := filepath.split(full)
	if parent != "" {
		_ = os.make_directory_all(parent)
	}
	return os.write_entire_file(full, data) == nil
}

storage_write_all_text :: proc(container: ^StorageContainer, path, data: string) -> bool {
	return storage_write_all_bytes(container, path, transmute([]byte)data)
}

storage_dispose :: proc(container: ^StorageContainer) {
	_ = container
}

file_system_init :: proc(fs: ^FileSystem, app: ^App) {
	fs.App = app
}

file_system_open_user_storage :: proc(fs: ^FileSystem) -> StorageContainer {
	root := ""
	if fs.App != nil {
		root = fs.App.UserPath
	}
	if root == "" {
		pref_path := SDL.GetPrefPath("", to_cstring(fs.App.Name))
		if pref_path != nil {
			root = string(cstring(pref_path))
		}
	}
	if root != "" {
		_ = os.make_directory_all(root)
	}
	return StorageContainer{Root = root, Writable = true}
}

file_system_open_title_storage :: proc(fs: ^FileSystem) -> StorageContainer {
	base_path := SDL.GetBasePath()
	root := ""
	if base_path != nil {
		root = string(base_path)
	}
	if root == "" {
		dir, err := os.get_working_directory(context.temp_allocator)
		if err == nil {
			root = dir
		}
	}
	return StorageContainer{Root = root, Writable = false}
}

file_system_open_user_storage_async :: proc(fs: ^FileSystem, callback: proc(storage: StorageContainer)) {
	if callback != nil {
		callback(file_system_open_user_storage(fs))
	}
}

file_system_open_title_storage_async :: proc(fs: ^FileSystem, callback: proc(storage: StorageContainer)) {
	if callback != nil {
		callback(file_system_open_title_storage(fs))
	}
}

file_system_open_file_dialog :: proc(fs: ^FileSystem, title: string, filters: []DialogFilter, callback: DialogCallback) {
	_ = fs
	_ = title
	_ = filters
	if callback != nil {
		callback(DialogResult{Cancelled = true})
	}
}

file_system_open_folder_dialog :: proc(fs: ^FileSystem, title: string, callback: DialogCallbackSingleFile) {
	_ = fs
	_ = title
	if callback != nil {
		callback("")
	}
}

file_system_save_file_dialog :: proc(fs: ^FileSystem, title: string, filters: []DialogFilter, callback: DialogCallbackSingleFile) {
	_ = fs
	_ = title
	_ = filters
	if callback != nil {
		callback("")
	}
}

open_user_storage :: file_system_open_user_storage
open_title_storage :: file_system_open_title_storage
open_user_storage_async :: file_system_open_user_storage_async
open_title_storage_async :: file_system_open_title_storage_async
open_file_dialog :: file_system_open_file_dialog
open_folder_dialog :: file_system_open_folder_dialog
save_file_dialog :: file_system_save_file_dialog

FileSystemInit :: file_system_init
OpenUserStorage :: file_system_open_user_storage
OpenTitleStorage :: file_system_open_title_storage
OpenUserStorageAsync :: file_system_open_user_storage_async
OpenTitleStorageAsync :: file_system_open_title_storage_async
OpenFileDialog :: file_system_open_file_dialog
OpenFolderDialog :: file_system_open_folder_dialog
SaveFileDialog :: file_system_save_file_dialog

Exists :: storage_exists
FileExists :: storage_file_exists
DirectoryExists :: storage_directory_exists
EnumerateDirectory :: storage_enumerate_directory
CreateDirectory :: storage_create_directory
Remove :: storage_remove
ReadAllBytes :: storage_read_all_bytes
ReadAllText :: storage_read_all_text
WriteAllBytes :: storage_write_all_bytes
WriteAllText :: storage_write_all_text
DisposeStorage :: storage_dispose

StorageDebugString :: proc(container: ^StorageContainer) -> string {
	return fmt.aprintf("StorageContainer{root=%q, writable=%v}", container.Root, container.Writable)
}
