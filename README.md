<h1 align="center">
	<img src="https://raw.githubusercontent.com/vector-im/element-desktop/develop/res/img/element.png" alt="Element" height=200 width=200 align="middle">
	Element AppImage
</h1>

A glossy Matrix collaboration client for desktop.

Continuous Integration to create preconfigured AppImages of the Element
Matrix desktop client. [Featured AppImages](https://matrix.org/blog/2020/08/07/this-week-in-matrix-2020-08-07#new-appimage-for-the-element-desktop-matrix-client) ([almost](https://github.com/vector-im/element-web/issues/4766) official :smile:)

## Getting Started
* Go to [Releases](https://github.com/srevinsaju/element-appimage/releases)
* Download the latest the Element-x.x.x.AppImage. 

### Executing
#### File Manager
Just double click the `*.AppImage` file and you are done!

> In normal cases, the above method should work, but in some rare cases
the `+x` permissisions. So, right click > Properties > Allow Execution

#### Terminal 
```bash
./Element-*.AppImage
```
```bash
chmod +x Element-*.AppImage
./Element-*.AppImage
```

In case, if FUSE support libraries are not installed on the host system, it is 
still possible to run the AppImage

```bash
./Element-*.AppImage --appimage-extract
cd squashfs-root
./AppRun
```

## License 
Element Desktop is licensed under the Apache License 2.0. 
The continuous integration (.github/workflows/continuous.yml) is licensed under
MIT License. Unless explicitly mentioned, all others are licensed under Apache License 2.0 
or the corresponding license as defined by New Vector

