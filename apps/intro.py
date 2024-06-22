from pyspark import SparkConf, SparkContext

conf = SparkConf()
conf.setMaster("spark://localhost:7077")
conf.setAppName("Python App")
conf.set("spark.driver.port", "7077")
conf.set("spark.driver.host", "localhost")
conf.set("spark.driver.bindAddress", "localhost")

sc = SparkContext(sparkHome="${SPARK_HOME}", conf=conf).getOrCreate()
sc.setLogLevel("ERROR")

print(sc.version)
print(sc.pythonVer)
print(sc.master)
print(sc.sparkHome)
print(sc.sparkUser())
print(sc.defaultParallelism)

rdd = sc.parallelize([("a",7),("a",2),("b",2)])

print(rdd.collect())
print(rdd.getNumPartitions())
print(rdd.count())
print(rdd.countByKey())
print(rdd.countByValue())

rdd2 = sc.parallelize(range(10), 2)
print(rdd2.collect())
print(rdd2.glom().collect())
print(rdd2.sum())

sc.stop()
