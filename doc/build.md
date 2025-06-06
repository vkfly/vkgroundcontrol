# 编译

## Linux

### 编译环境

编译需要的环境：Qt6/CMake/GStreamer/GCC

根据用户所使用的Linux发行版不同，安装方法也不一样。

### 下载代码

```shell
git clone xxxx
```

### 编译

```shell
cd vkgcs
mkdir build
cd build
cmake ..
make -j8
```

编译过程中，会根据使用的GStreamer版本下载相应的GStreamer插件，如果无法下载，可以尝试换一个代理服务。比如：

```shell
https_proxy=socks://127.0.0.1:7890 cmake ..
```

编译结束后，在Release目录会生成最终的可执行文件VKGroundControl。

如果希望编译成Debug版本以便调试，可以把上面的cmake命令改成如下的命令：

```shell
cmake -DCMAKE_BUILD_TYPE=Debug ..
```

改成Debug版本后，编译出来的可执行文件会在Debug目录下

## Windows

**注意：由于VKGS使用Qt6，因此只支持Windows 10及以上的版本。**

**注意：建议使用QtCreator编译Windows版本。**

因为同样是使用cmake，因此如果出现问题，可以参考Linux的解决

## Android

**注意：建议使用QtCreator来编译Android版本。**

### 编译环境

Qt版本建议6.7，因为后期的Qt不支持Android 8.0及以下的版本，在某些早期的遥控器上无法运行。

编译安卓版本还需要安装Android NDK和Android SDK，具体版本可以参考Qt官网链接：https://doc.qt.io/qt-6.7/mobiledevelopment.html

在QtCreator中可以比较方便的下载安装NDK和SDK，如下图所示：

![qtcreator-android-sdk]("img/qtcreator-android-sdk.webp")

编译时候的选项如下图所示：

![qtcreator-android-config]("img/qtcreator-android-config.webp")

安卓版本需要的GStreamer库已经包含在代码里，不依赖系统安装的GStreamer版本。