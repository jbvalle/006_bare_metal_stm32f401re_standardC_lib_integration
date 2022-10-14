# Binaries
CC = arm-none-eabi-gcc

# Directories
SRC_DIR = src
INC_DIR = inc
OBJ_DIR = obj
DEB_DIR = debug
STARTUP_DIR = startup

# Files
SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(STARTUP_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(SRC))
OBJ := $(patsubst $(STARTUP_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(OBJ))
LS  := $(wildcard $(STARTUP_DIR)/*.ld) 

INTERFACE_PATH = /usr/share/openocd/scripts/interface/stlink-v2.cfg
TARGET_PATH = /usr/share/openocd/scripts/target/stm32f4x.cfg
# Flags
MARCH = cortex-m4
CFLAGS = -g -Wall -mcpu=$(MARCH) -mthumb -mfloat-abi=soft
LFLAGS = -mcpu=$(MARCH) -mthumb -mfloat-abi=soft --specs=nano.specs -T $(LS) -Wl,-Map=$(DEB_DIR)/main.map

# Targets
TARGET = $(DEB_DIR)/main.elf

all: $(OBJ) $(TARGET)

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c |  mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(STARTUP_DIR)/%.c | mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(TARGET) : $(OBJ) | mkdeb
	$(CC) $(LFLAGS) -o $@ $^

flash:
	openocd -f $(INTERFACE_PATH) -f $(TARGET_PATH) &
	gdb-multiarch $(TARGET) -x $(STARTUP_DIR)/init.gdb
	pkill openocd

debug_elf:
	arm-none-eabi-objdump -h $(TARGET)

mkobj:
	mkdir -p $(SRC_DIR)/$(OBJ_DIR)

mkdeb:
	mkdir -p $(DEB_DIR)

clean:
	rm -rf $(SRC_DIR)/$(OBJ_DIR) $(TARGET)

show:
	echo $(SRC_SMI)

.PHONY = clean mkdeb mkobj flash debug_elf
