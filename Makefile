.PHONY: all clean build-bootloader build-kernel build-gui build-all

# Компилятор и флаги
CC = gcc
CXX = g++
NASM = nasm
CFLAGS = -Wall -Wextra -ffreestanding -fno-pie -m32
CXXFLAGS = -Wall -Wextra -std=c++17 -fPIC
NASMFLAGS = -f elf32

# Директории
BUILD_DIR = build
BOOTLOADER_DIR = bootloader
KERNEL_DIR = kernel
GUI_DIR = gui
FILE_MANAGER_DIR = file-manager
NEOFETCH_DIR = neofetch

# Файлы
BOOTLOADER_OUT = $(BUILD_DIR)/bootloader.bin
KERNEL_OUT = $(BUILD_DIR)/kernel.bin
GUI_OUT = $(BUILD_DIR)/archyos-gui
FILE_MANAGER_OUT = $(BUILD_DIR)/file-manager
NEOFETCH_OUT = $(BUILD_DIR)/neofetch

# Основная цель
all: build-all

build-all: $(BUILD_DIR) build-bootloader build-kernel build-gui build-file-manager build-neofetch
	@echo "✓ ArchyOS успешно собрана!"

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Сборка bootloader
build-bootloader: $(BUILD_DIR)
	@echo "Компилирование bootloader..."
	$(NASM) $(NASMFLAGS) $(BOOTLOADER_DIR)/boot.asm -o $(BOOTLOADER_OUT)
	@echo "✓ Bootloader собран"

# Сборка ядра
build-kernel: $(BUILD_DIR)
	@echo "Компилирование ядра..."
	$(CC) $(CFLAGS) -c $(KERNEL_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o
	$(CC) $(CFLAGS) -c $(KERNEL_DIR)/io.c -o $(BUILD_DIR)/io.o
	$(CC) -T $(KERNEL_DIR)/linker.ld -ffreestanding -O2 -nostdlib \
		$(BUILD_DIR)/kernel.o $(BUILD_DIR)/io.o -o $(KERNEL_OUT)
	@echo "✓ Ядро собрано"

# Сборка GUI
build-gui: $(BUILD_DIR)
	@echo "Компилирование GUI..."
	$(CXX) $(CXXFLAGS) -c $(GUI_DIR)/main.cpp -o $(BUILD_DIR)/gui_main.o
	$(CXX) $(CXXFLAGS) -c $(GUI_DIR)/window.cpp -o $(BUILD_DIR)/gui_window.o
	$(CXX) -o $(GUI_OUT) $(BUILD_DIR)/gui_main.o $(BUILD_DIR)/gui_window.o
	@echo "✓ GUI собран"

# Сборка файлового менеджера
build-file-manager: $(BUILD_DIR)
	@echo "Компилирование файлового менеджера..."
	$(CXX) $(CXXFLAGS) -c $(FILE_MANAGER_DIR)/file_manager.cpp -o $(BUILD_DIR)/fm.o
	$(CXX) $(CXXFLAGS) -c $(FILE_MANAGER_DIR)/main.cpp -o $(BUILD_DIR)/fm_main.o
	$(CXX) -o $(FILE_MANAGER_OUT) $(BUILD_DIR)/fm.o $(BUILD_DIR)/fm_main.o
	@echo "✓ Файловый менеджер собран"

# Сборка Neofetch
build-neofetch: $(BUILD_DIR)
	@echo "Компилирование Neofetch..."
	$(CXX) $(CXXFLAGS) -c $(NEOFETCH_DIR)/neofetch.cpp -o $(BUILD_DIR)/neofetch.o
	$(CXX) $(CXXFLAGS) -c $(NEOFETCH_DIR)/main.cpp -o $(BUILD_DIR)/neofetch_main.o
	$(CXX) -o $(NEOFETCH_OUT) $(BUILD_DIR)/neofetch.o $(BUILD_DIR)/neofetch_main.o
	@echo "✓ Neofetch собран"

# Очистка
clean:
	@echo "Очистка файлов сборки..."
	rm -rf $(BUILD_DIR)
	@echo "✓ Очистка завершена"

# Помощь
help:
	@echo "ArchyOS - Минималистичная ОС с GUI"
	@echo ""
	@echo "Доступные команды:"
	@echo "  make all                - собрать всю ArchyOS"
	@echo "  make build-bootloader   - собрать bootloader"
	@echo "  make build-kernel       - собрать ядро"
	@echo "  make build-gui          - собрать GUI"
	@echo "  make build-file-manager - собрать файловый менеджер"
	@echo "  make build-neofetch     - собрать Neofetch"
	@echo "  make clean              - удалить файлы сборки"
	@echo "  make help               - показать эту справку"
