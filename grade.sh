CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# checking if correct files are submitted
if [[ -f student-submission/ListExamples.java ]]
then
  echo "File found"
else 
  echo "File not found"
  exit
fi

# Moving files to grading-area
cp -r student-submission/*.java grading-area
cp -r lib grading-area
cp -r TestListExamples.java grading-area

# compiling the code
cd grading-area
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
  echo "Code did not compile"
  exit
else
  echo "Code compiled"
fi

# Running tests
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > testOutput.txt
grep_output=$(grep "OK" testOutput.txt)
if [[ -n "$grep_output" ]]
then
  echo "100%"
else
  grep_tests=$(grep "Tests run" testOutput.txt | cut -d " " -f3 | cut -d "," -f1)
  grep_fails=$(grep "Tests run" testOutput.txt | cut -d " " -f6)
  grep_passes=$((grep_tests-grep_fails))
  echo Your score is "$grep_passes"/"$grep_tests"
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
