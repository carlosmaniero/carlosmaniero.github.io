Title: Asyncio Handle Blocking Functions
Date: 2016-02-03 22:00
Category: Python
Tags: python, asyncio


When we use concurrency, all [tasks](https://docs.python.org/3/library/asyncio-task.html) are running in the same thread. 
When the `await` or `yield from` keywords is used in the task, 
the task is suspended and the [EventLoop](https://docs.python.org/3/library/asyncio-eventloop.html) executes the next task.
This will be occur until all tasks are completed.

If you have a blocking function, by example, a web request.
All tasks will wait the blocking function be completed. See this example:


```py
import asyncio
import time


def slow_function():
    time.sleep(3)
    return 42


@asyncio.coroutine
def test1():
    slow_function()
    print('Finish test1')


@asyncio.coroutine
def test2():
    for i in range(0, 10):
        print(i)
        yield from asyncio.sleep(0.5)
    print('Finish test2')


loop = asyncio.get_event_loop()
loop.run_until_complete(
    asyncio.wait([
        test1(),
        test2()
    ])
)
```

Output

```
Finish test1
0
1
2
3
4
5
6
7
8
9
Finish test2
```

How can we see, the `EventLoop` run the test1
and the test2 only starts after the test1 is completed.

If you need execute a blocking functions you can use the 
[run_in_executor()](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.BaseEventLoop.run_in_executor)
method of the `EventLoop`, this will be run the function in an executor 
(by default the [ThreadPoolExecutor](https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ThreadPoolExecutor)).


The usage of `run_in_executor` is like this:


```py
loop.run_in_executor(executor=None, fn, *args)
```

When the `*args` will be the args of `fn`.

Now, the same example using the `run_in_executor` and its output.


```py
import asyncio
import time


def slow_function():
    time.sleep(3)
    return 42


@asyncio.coroutine
def test1(loop):
    yield from loop.run_in_executor(None, slow_function)
    print('Finish test1')


@asyncio.coroutine
def test2():
    for i in range(0, 10):
        print(i)
        yield from asyncio.sleep(0.5)
    print('Finish test2')


loop = asyncio.get_event_loop()
loop.run_until_complete(
    asyncio.wait([
        test1(loop),
        test2()
    ])
)
```

Output:

```
0
1
2
3
4
5
Finish test1
6
7
8
9
Finish test2
```

Now, the test2 can be executed while the test1 waits from the `slow_function` response.
