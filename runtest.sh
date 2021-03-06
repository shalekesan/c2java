#!/bin/bash
cd testcases

for name in `ls | sort`; do
	cd $name
  ../../c2java $name.sc $name.java
  for in in `find data -name "*.in" | sort`; do
    echo "Testing $name ${in%.in} ..."
    javac $name.java >> ../../log 2>&1
    timeout 10s java $name < $in > output.log
    if [ $? -eq 124 ]; then
      echo "FAIL: timeout"
    else
      diff -q -B "${in%.in}.out" output.log
    fi
	rm -f output.log *.class
  done
  cd ..
done
