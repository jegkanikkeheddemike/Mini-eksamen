class CMath {
  boolean within(float low, float middle, float high) {
    if (low < middle && middle < high) {
      return true;
    }
    return false;
  }
}
CMath math = new CMath();
