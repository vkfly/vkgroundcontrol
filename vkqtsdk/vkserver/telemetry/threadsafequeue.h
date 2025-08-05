#ifndef THREADSAFEQUEUE_H
#define THREADSAFEQUEUE_H
#include <QQueue>
#include <QMutexLocker>

template<typename T>
class ThreadSafeQueue {
public:
    void enqueue(const T& value) {
        QMutexLocker locker(&m_mutex);
        m_queue.enqueue(value);
    }

    T dequeue() {
        QMutexLocker locker(&m_mutex);
        if (m_queue.isEmpty()) {
            return T();
        }
        return m_queue.dequeue();
    }

    int size() {
        QMutexLocker locker(&m_mutex);
        return m_queue.length();
    }

    bool isEmpty() const {
        QMutexLocker locker(&m_mutex);
        return m_queue.isEmpty();
    }

private:
    QQueue<T> m_queue;
    mutable QMutex m_mutex;
};

#endif // THREADSAFEQUEUE_H
