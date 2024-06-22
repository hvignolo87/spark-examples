from pyspark import SparkConf, SparkContext

conf = SparkConf()
conf.setMaster("spark://localhost:7077")
conf.setAppName("Python App")
conf.set("spark.driver.port", "7077")
conf.set("spark.driver.host", "localhost")
conf.set("spark.driver.bindAddress", "localhost")

sc = SparkContext(sparkHome="${SPARK_HOME}", conf=conf).getOrCreate()

print(sc.parallelize(range(1000000), 100).glom().collect())

sc.stop()
