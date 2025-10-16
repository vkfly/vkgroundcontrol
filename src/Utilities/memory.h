#pragma once

#include <stdint.h>

namespace MemoryHelper {

    void dumpBytes(const void *data, int len);

    namespace LittleEndian {
        int16_t getS16(const uint8_t buf[]);
        uint16_t getU16(const uint8_t buf[]);
        void putI16(uint8_t buf[], int16_t v);
        int32_t getS32(const uint8_t buf[]);
        uint32_t getU32(const uint8_t buf[]);
        int64_t getS64(const uint8_t buf[]);
        uint64_t getU64(const uint8_t buf[]);
        void putI32(uint8_t buf[], int32_t v);
        void putFloat(uint8_t buf[], float v);
        void putI64(uint8_t buf[], int64_t v);
    };

    class Reader {
    private:
        const uint8_t *head, *tail, *p;

    public:
        Reader(void *data, int len);

        uint16_t readU16LE();
        int16_t readS16LE();
        uint8_t readU8();
        int8_t readS8();
        uint32_t readU32LE();
        int32_t readS32LE();
        uint64_t readU64LE();
        int64_t readS64LE();
        float readFloatLE();
        void readBytes(int len, uint8_t out[]);
    };

    class Writer {
    private:
        uint8_t *head, *tail, *p;

    public:
        Writer(void *data, int len);

        void writeI16LE(int16_t v);
        void writeI8(int8_t v);
        void writeI32LE(int32_t v);
        void writeFloatLE(float v);
        void writeBytes(void *data, int len);
    };
};

