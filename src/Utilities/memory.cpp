#include "memory.h"

#include <stdio.h>
#include <string.h>

namespace MemoryHelper {

void dumpBytes(const void *data, int len) {
    const uint8_t *p = (const uint8_t *) data;
    for (; len > 0; p++, len--) {
        printf("%02X ", *p);
    }
    printf("\n");
}

namespace LittleEndian {

int16_t getS16(const uint8_t buf[]) {
    return buf[0] + (buf[1] << 8);
}

uint16_t getU16(const uint8_t buf[]) {
    return buf[0] + (buf[1] << 8);
}

void putI16(uint8_t buf[], int16_t v) {
    buf[0] = (uint8_t)v;
    buf[1] = (uint8_t)(v >> 8);
}

int32_t getS32(const uint8_t buf[]) {
    return buf[0] + (buf[1] << 8) + (buf[2] << 16) + (buf[3] << 24);
}

uint32_t getU32(const uint8_t buf[]) {
    return buf[0] + (buf[1] << 8) + (buf[2] << 16) + (buf[3] << 24);
}

int64_t getS64(const uint8_t buf[]) {
    int64_t sum = 0;
    for (int i = 0; i < 8; i++) {
        long d = buf[i] & 0xFF;
        sum += d << (i * 8);
    }
    return sum;
}

uint64_t getU64(const uint8_t buf[]) {
    return (uint64_t)getS64(buf);
}


void putI32(uint8_t buf[], int32_t v) {
    buf[0] = (uint8_t)v;
    buf[1] = (uint8_t)(v >> 8);
    buf[2] = (uint8_t)(v >> 16);
    buf[3] = (uint8_t)(v >> 24);
}

void putFloat(uint8_t buf[], float v) {
    int32_t *iv = (int32_t *) &v;
    putI32(buf, *iv);
}

void putI64(uint8_t buf[], int64_t v) {
    for (int i = 0; i < 8; i++) {
        buf[i] = (uint8_t) v;
        v >>= 8;
    }
}

}

Reader::Reader(void *data, int len) {
    head = (const uint8_t *) data;
    tail = head + len;
    p = head;
}

uint16_t Reader::readU16LE() {
    if (p + 2 > tail) {
        return 0;
    }
    uint16_t r = LittleEndian::getS16(p);
    p += 2;
    return r;
}

int16_t Reader::readS16LE() {
    return (int16_t) readU16LE();
}

uint8_t Reader::readU8() {
    if (p >= tail) {
        return 0;
    }
    return *p++;
}

int8_t Reader::readS8() {
    return (int8_t) readU8();
}

float Reader::readFloatLE() {
    uint32_t d = readU32LE();
    return *((float *)&d);
}

uint32_t Reader::readU32LE() {
    if (p + 4 > tail) {
        return 0;
    }
    uint32_t r = LittleEndian::getS32(p);
    p += 4;
    return r;
}

int32_t Reader::readS32LE() {
    return (int32_t) readU32LE();
}

uint64_t Reader::readU64LE() {
    if (p + 8 > tail) {
        return 0;
    }
    uint64_t r = LittleEndian::getU64(p);
    p += 8;
    return r;
}

int64_t Reader::readS64LE() {
    return (int64_t) readU64LE();
}

void Reader::readBytes(int len, uint8_t out[]) {
    if (p + len > tail) {
        return;
    }
    memcpy(out, p, len);
    p += len;
}

Writer::Writer(void *data, int len) {
    head = (uint8_t *) data;
    tail = head + len;
    p = head;
}

void Writer::writeI16LE(int16_t v) {
    if (p + 2 > tail) {
        return;
    }
    LittleEndian::putI16(p, v);
    p += 2;
}

void Writer::writeI8(int8_t v) {
    if (p >= tail) {
        return;
    }
    *p++ = (uint8_t) v;
}

void Writer::writeI32LE(int32_t v) {
    if (p + 4 > tail) {
        return;
    }
    LittleEndian::putI32(p, v);
    p += 4;
}

void Writer::writeFloatLE(float v) {
    if (p + 4 > tail) {
        return;
    }
    LittleEndian::putFloat(p, v);
    p += 4;
}

void Writer::writeBytes(void *data, int len) {
    if (p + 4 > tail) {
        return;
    }
    memcpy(p, data, len);
    p += len;
}

}