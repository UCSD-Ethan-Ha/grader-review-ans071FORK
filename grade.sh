CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
SCORE=100

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ -f student-submission/ListExamples.java ]; then
    if grep -q 'filter' student-submission/ListExamples.java && grep -q 'merge' student-submission/ListExamples.java; 
    then
        echo "ListExamples.java exists and contains the required static methods."
    else
        echo "ListExamples.java is missing one/both of the required static methods. -20 points."
        SCORE=$((SCORE - 20))
    fi
else
    echo "ListExamples.java not found. 0 points."
    SCORE=0
    exit 1
fi

# if [ -f student-submission/ListExamples.java ]; 
# then
#     if grep -q 'static List<String> filter(List<String> s, StringChecker sc)' student-submission/ListExamples.java && grep -q 'static List<String> merge(List<String> list1, List<String> list2)' student-submission/ListExamples.java; 
#     then
#         echo "ListExamples.java exists and contains the required static methods."
#     else
#         echo "ListExamples.java is missing one/both of the required static methods."
#     fi
# else
#     echo "ListExamples.java not found."
# fi

cp *.java grading-area
cp student-submission/*.java grading-area

javac -cp $CPATH grading-area/*.java > compilation_errors.txt 2>&1
if [ $? -eq 0 ]; 
then
    java -cp $CPATH org.junit.runner.JUnitCore
    echo "Compilation successful."
else
    echo "Compilation failed. Here are the errors. -10 points."
    cat compilation_errors.txt
    SCORE=$((SCORE - 10))
fi

if [ $SCORE -lt 0 ]; 
then
    SCORE=0
fi
echo "Score: $SCORE"

# Draw a picture/take notes on the directory structure that's set up after getting to this point

# Then, add here code to compile and run, and do any post-processing of the tests