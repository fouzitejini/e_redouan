extension SumCollection<T> on List<T> {
  num sumTotal(num Function(T element) f) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}