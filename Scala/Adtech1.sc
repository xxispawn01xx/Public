import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import scala.io.Source
val curDir = System.getProperty("user.dir");
println(curDir)
//?
//val numRecords= data.count(_ == 'p')
// Remember most of this was meant to run in spark-shell

// /src/main/data/
///**
// * A simple Spark app in Scala
// */
//object ScalaApp {
//vi tennis.csv read the first few lines this way
  def main(args: Array[String]) {
    val sc = new SparkContext("local[2]", "First Spark App")

    // we take the raw data in CSV format and convert it into a set of records of the form (user, product, price)
    val data = sc.textFile("H:/Ali/Bit Briefcase/Big Data/Kaggle/CTR/ctr_set.csv")
    val parsedData = data.map {
    line => val parts = line.split(',').map(_.toDouble)
      LabeledPoint(parts(0), Vectors.dense(parts.tail)) }

//  H:/Ali/Bit Briefcase/Big Data/Kaggle/CTR/ctr_set.csv
//  C:/Stuff/Programming/Adtech/src/main/data/train.csv
val readsizeof = 20000
val nooflines = 0
//  ( while((linesread <- length(readLines(testcon,readsizeof))) > 0 )nooflines <- nooflines+linesread )
//  close(testcon)
  println("no. of lines" + nooflines)
//  total # of 40,428,968 rows in train.csv file size is 6163 MB
//  ~=6560 rows per MB

//
//    // let's count the number of purchases
//    val numRecords = data.count()
//
//    // let's count how many unique users made purchases
//    val uniqueUsers = data.map { case (user, product, price) => user }.distinct().count()
//
//    // let's sum up our total revenue
//    val totalRevenue = data.map { case (user, product, price) => price.toDouble }.sum()
//
//    // let's find our most popular product
//    val productsByPopularity = data
//      .map { case (user, product, price) => (product, 1) }
//      .reduceByKey(_ + _)
//      .collect()
//      .sortBy(-_._2)
//    val mostPopular = productsByPopularity(0)
//
//    // finally, print everything out
//    println("Total purchases: " + numRecords)
//    println("Unique users: " + uniqueUsers)
//    println("Total revenue: " + totalRevenue)
//    println("Most popular product: %s with %d purchases".format(mostPopular._1, mostPopular._2))
//
    sc.stop()
  }
//
//}
import org.apache.spark.mllib.linalg.Vectors
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.classification.
LogisticRegressionWithLBFGS
val points = Array(
  LabeledPoint(click,(~ C1+C15+C16+C18+banner_pos+device_conn_type+site_category+app_category))
//click vs all the signifcant variables

val spiderRDD = sc.parallelize(points)

val lr = new LogisticRegressionWithLBFGS().
  setIntercept(true)
val model = lr.run(spiderRDD)
val predict = model.predict(Vectors.dense(0.938))



val f    = udf { (v:String, prefix:String ) => s"$prefix:$v" }
val hour = udf { (v:String ) => v slice( 6, 8 ) }