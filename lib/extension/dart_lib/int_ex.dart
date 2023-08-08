part of axc_bedrock;

class AxcIntSpace {
  AxcIntSpace(int obj) {
    //构造方法
    this.base = obj;
  }

  int base = 0;
}

extension IntExtension on int {
  AxcIntSpace get axc {
    return AxcIntSpace(this);
  }
}

/// 数据转换
extension IntToTransform on AxcIntSpace {}
