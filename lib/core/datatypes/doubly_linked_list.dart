import 'package:flutter_base_template/core/datatypes/node.dart';

class DoublyLinkedList<T> {
  Node<T>? head;
  Node<T>? tail;
  int length = 0;

  void prepend(T data) {
    Node<T> newNode = Node(data);
    if (head != null) {
      newNode.next = head;
      head?.previous = newNode;
      head = newNode;
    } else {
      head = newNode;
      tail = newNode;
    }
    length++;
  }

  void append(T data) {
    Node<T> newNode = Node(data);
    if (head != null) {
      newNode.previous = tail;
      tail?.next = newNode;
      tail = newNode;
    } else {
      head = newNode;
      tail = newNode;
    }
    length++;
  }

  // <T> necessary?
  T at(int index) {
    Node<T>? currentNode = head;
    int currentIndex = 0;
    while (currentNode != null && currentIndex < index) {
      currentNode = currentNode.next;
      currentIndex++;
    }
    return currentNode!.data;
  }

  void removeAt(int index) {
    if (index >= length || index < 0) {
      return;
    }
    if (index == 0) {
      _removeHead();
    } else if (index == length - 1) {
      _removeTail();
    } else {
      if (index < (length / 2).floor()) {
        _removeStartAtHead(index);
      } else {
        _removeStartAtTail(index);
      }
    }
  }

  void _removeHead() {
    if (head != null) {
      head = head!.next;
      length--;
      if (head != null) {
        head!.previous = null;
      } else {
        tail = null;
      }
    }
  }

  void _removeTail() {
    if (tail != null) {
      tail = tail!.previous;
      length--;
      if (tail != null) {
        tail!.next = null;
      } else {
        head = null;
      }
    }
  }

  void _removeStartAtHead(int index) {
    Node<T>? currentNode = head;
    int currentIndex = 0;
    while (currentIndex < index && currentNode != null) {
      currentNode = currentNode.next;
      currentIndex++;
    }
    if (currentNode != null && currentIndex == index) {
      currentNode.previous!.next = currentNode.next;
      currentNode.next!.previous = currentNode.previous;
    }
  }

  void _removeStartAtTail(int index) {
    Node<T>? currentNode = head;
    int currentIndex = length - 1;
    while (currentIndex > index && currentNode != null) {
      currentNode = currentNode.previous;
      currentIndex--;
    }
    if (currentNode != null && currentIndex == index) {
      currentNode.next!.previous = currentNode.previous;
      currentNode.previous!.next = currentNode.next;
    }
  }
}
