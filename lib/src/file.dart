part of umiuni2d_io_dartio;

class Directory extends umi.Directory {

  dio.FileSystemEntity fe;
  Directory(this.fe);

  String get name => dpath.basename(fe.path);

  String get path => fe.path;

  Future<bool> isDirectory() async{
    if(!await exists()) {
      return false;
    }
    if(fe is dio.Directory) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> isFile() async{
    if(!await exists()) {
      return false;
    }
    if(fe is dio.File) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> exists() async{
    return fe.exists();
  }
}

class File extends umi.File{
  dio.FileSystemEntity fe;
  File(this.fe);

  //
  //
  String get name => dpath.basename(fe.path);

  String get path => fe.path;

  Future<bool> isDirectory() async{
    if(!await exists()) {
      return false;
    }
    if(fe is dio.Directory) {
      return true;
    } else {
      return false;
    }
  }
  Future<bool> isFile() async{
    if(!await exists()) {
      return false;
    }
    if(fe is dio.File) {
      return true;
    } else {
      return false;
    }
  }


  Future<bool> exists() async{
    return fe.exists();
  }

  @override
  Future<int> writeAsBytes(List<int> buffer, int offset) async {
    dio.RandomAccessFile af = await (fe as dio.File).open(mode: dio.FileMode.APPEND);
    if(af == null) {
      af = await (this.fe as dio.File).open(mode: dio.FileMode.APPEND);
    }
    await af.setPosition(offset);
    await af.writeFrom(buffer);
    await af.close();
    return buffer.length;
  }

  @override
  Future<List<int>> readAsBytes(int offset, int length) async {
    dio.RandomAccessFile af = await (fe as dio.File).open(mode: dio.FileMode.APPEND);
    await af.setPosition(offset);
    List<int> ret = await af.read(length);
    await af.close();
    return ret;
  }

  @override
  Future<int> getLength() async {
    return (fe as dio.File).length();
  }

  @override
  Future<int> truncate(int fileSize) async {
    dio.RandomAccessFile af = await (fe as dio.File).open(mode: dio.FileMode.APPEND);
    int s = await getLength();
    if(fileSize >= s) {
      return s;
    }
    await af.truncate(fileSize);
    int ret = await getLength();
    await af.close();
    return ret;
  }
}
