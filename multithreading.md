# Multithreading Guide

## Concepts and Terms:
- **mutex:** Mutually-exclusive lock that a thread can hold, release, lock,
  unlock. Used to provide mutual exclusion to threads when accessing a shared
  resource.
- **condition variable (cv):** A variable that a thread can atomically hand a
  held lock to, and sleep until the thread is woken by signaling
  (or broadcasting) to the cv.
- **atomic:** Adjective describing an operation being completed from start to
  finish without any other operations interrupting.

## Using Multithreading in C++:

### Includes to Use:
```cpp
#include <thread> // std::thread
#include <mutex>  // std::mutex
#include <cv>     // std::cv
```

### How to Use:

We will do it by example. Assume the imports, `using`, etc are done correctly.
Imagine you are writing a camera driver and a camera driver benchmarker. Each
will run on a separate thread and utilize a shared resource: a queue of images
to handle.

NOTE: This is not exactly how the camera driver or the benchmarker would be
implemented. Instead, this just gives a reference to how using threads and
shared resources is managed.

### `main.cpp`:
```cpp
std::queue<cv2::Mat> images();

std::mutex queue_lock;
std::cv queue_empty;

int main() {
    // Create the threads; set them to call these functions
    std::thread driver(cameraDriver);
    std::thread benchmarker(benchmarker);
}
```

### `driver.cpp`:
```cpp
void cameraDriver() {
    while (1) {
        // Fetch the image from the camera
        // (can be done in sync w/ benchmarker)
        cv2::Mat image = getImage();

        // Acquire the lock on the shared resource (the queue)
        queue_lock.lock();

        // Add image to the shared queue
        images.push(image);

        // Release the lock on the shared queue
        queue_lock.unlock();

        // Signal any thread waiting because the queue was empty
        queue_empty.signal();
    }
}
```
<details>
<summary>driver.cpp without the comments</summary>
<p>

```cpp
void cameraDriver() {
    while (1) {
        cv2::Mat image = getImage();
        queue_lock.lock();
        images.push(image);
        queue_lock.unlock();
        queue_empty.signal();
    }
}
```

</p>
</details>

### `benchmarker.cpp`:
```cpp
void benchmarker() {
    while (1) {
        // Acquire the lock on the shared resource (the queue)
        queue_lock.lock();

        // If the queue is empty, we cannot try and pop from it...
        // So, we must wait on the cv if it is empty
        // Use a while loop to verify the condition when woken up
        while (images.empty()) {
            // Pass the shared resource lock to release it while we wait
            queue_empty.wait(queue_lock)
        }

        // This thread is holding the lock when we return from cv::wait

        // Pop image from the shared queue
        cv2::Mat image = images.front();
        images.pop();

        // Release the lock on the shared queue
        queue_lock.unlock();

        // Process the iamge somehow...
        process(image);
    }
}
```

<details>
<summary>benchmarker.cpp without the comments</summary>
<p>

```cpp
void benchmarker() {
    while (1) {
        queue_lock.lock();
        while (images.empty()) {
            queue_empty.wait(queue_lock)
        }
        cv2::Mat image = images.front();
        images.pop();
        queue_lock.unlock();
        process(image);
    }
}
```

</p>
</details>
