part of umiuni2d_io_dartio;

class FileSystem extends umi.FileSystem{

  umi.Entry _currentDirectory = null;
  FileSystem() {}

  @override
  Future<FileSystem> checkPermission() async {
    //
    // this method is for html5 filesystem api.
    // flutter return true.
    return this;
  }

  @override
  Future<FileSystem> mkdir(String path) async {
    path = await toAbsoltePath(path);
    dio.Directory d = new dio.Directory(path);
    if(false == await d.exists()) {
      d.create(recursive: false);
    }
    return this;
  }

  @override
  Future<FileSystem> rm(String path,{bool recursive: false}) async {
    path = await toAbsoltePath(path);
    bool isFile = await dio.FileSystemEntity.isFile(path);
    if(isFile) {
      dio.File d = new dio.File(path);
      d.delete(recursive: recursive);
    } else {
      dio.Directory d = new dio.Directory(path);
      if (await d.exists()) {
        d.delete(recursive: recursive);
      }
    }
    return this;
  }

  Future<String> toAbsoltePath(String path) async {
    if(dpath.isAbsolute(path)) {
      return path;
    } else {
      //.replaceAll("file://", "")
      return dpath.normalize(dpath.joinAll([await (await wd()).path,path]));
    }
  }

  @override
  Stream<umi.Entry> ls(String path) async* {
    path = await toAbsoltePath(path);
    bool isFile = await dio.FileSystemEntity.isFile(path);
    if(isFile) {
      yield new File(new dio.File(path));
    } else {
      dio.Directory d = new dio.Directory(path);
      if (false == await d.exists()) {
        // not found
        print("## ${path}");
        throw "not found " + path;
      }
      await for (dio.FileSystemEntity f in d.list()) {
        if(f is dio.Directory) {
          yield new Directory(f);
        } else {
          yield new File(f);
        }
      }
    }
  }

  Future<umi.Entry> wd() async {
    if(_currentDirectory == null) {
      _currentDirectory = await getHomeDirectory();
    }
    return _currentDirectory;
  }

  Future<umi.Entry> getEntry(String path) async {
    path = await toAbsoltePath(path);
    if(true == await dio.FileSystemEntity.isDirectory(path)) {
      dio.Directory d = new dio.Directory(path);
      return new Directory(d);
    } else {
      dio.File f = new dio.File(path);
      if (false == await f.exists()) {
        await f.create();
      }
      return new File(f);
    }
  }

  Future<FileSystem> cd(String path) async {
    path = await toAbsoltePath(path);
    if(!await dio.FileSystemEntity.isDirectory(path)){
      throw "not directory ${path}";
    }
    dio.Directory f = new dio.Directory(path);
    _currentDirectory = new Directory(f);
    return this;
  }

  Future<bool> isFile(String path) async {
    path = await toAbsoltePath(path);
    return dio.FileSystemEntity.isFile(path);
  }

  Future<bool> isDirectory(String path) async {
    path = await toAbsoltePath(path);
    return dio.FileSystemEntity.isDirectory(path);
  }

  @override
  Future<umi.Directory> getHomeDirectory() async {
    return new Directory(dio.Directory.current);
  }

}