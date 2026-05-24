class Node<T> {
  T data;
  Node<T>? previous;
  Node<T>? next;
  Node(
    this.data, {
    this.previous,
    this.next,
  });
}
