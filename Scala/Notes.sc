val list = List(1, 2, 4, 2, 4, 7, 3, 2, 4)
// Using the provided count method this would yield the occurrences of each value in the list:
.map(x => l.count(_ == x))

List[Int] = List(1, 3, 3, 3, 3, 1, 1, 3, 3)
// This will yield a list of pairs where the first number is the number from the original list and the second number represents how often the first number occurs in the list:
.map(x => (x, l.count(_ == x)))
// outputs => List[(Int, Int)] = List((1,1), (2,3), (4,3), (2,3), (4,3), (7,1), (3,1), (2,3), (4,3))