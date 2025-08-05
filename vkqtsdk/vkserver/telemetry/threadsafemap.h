#ifndef THREADSAFEMAP_H
#define THREADSAFEMAP_H
#include <QMap>
#include <QMutexLocker>

template<class Key, class T>
class ThreadSafeMap {
public:
    void put(const Key& key, const T& value) {
        QMutexLocker locker(&m_mutex);
        map.insert(key, value);
    }

    T get(const Key& key) {
        QMutexLocker locker(&m_mutex);
        if (map.isEmpty()) {
            return T();
        }
        return map.value(key);
    }

    void remove(const Key& key) {
        QMutexLocker locker(&m_mutex);
        if (map.isEmpty()) {
            return;
        }
        map.remove(key);
    }

    QList<Key> keys() {
        QMutexLocker locker(&m_mutex);
        return map.keys();
    }

    int size() {
        QMutexLocker locker(&m_mutex);
        return map.size();
    }

    bool isEmpty() const {
        QMutexLocker locker(&m_mutex);
        return map.isEmpty();
    }

private:
    QMap<Key, T> map;
    mutable QMutex m_mutex;
};
#endif // THREADSAFEMAP_H
