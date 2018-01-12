#! /bin/sh

# OS specific support. $var _must_ be set to either true or false.
cygwin=false;
darwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true ;;
  Darwin*) darwin=true ;;
esac

if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD=$JAVA_HOME/jre/sh/java
    else
      JAVACMD=$JAVA_HOME/bin/java
    fi
  else
    JAVACMD=java
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Error: JAVA_HOME is not defined correctly."
  echo "  We cannot execute $JAVACMD"
  exit
fi

# add in the dependency .jar files
# The jar-files are in the same directory as this scriptfile !
# So remove the name of this script-file from the path and replace it
#   with *.jar
DIRNAME=`dirname $0`
DIRLIBS=${DIRNAME}/lib/*.jar
for i in ${DIRLIBS}
do
  if [ -z "$LOCALCLASSPATH" ] ; then
    LOCALCLASSPATH=$i
  else
    LOCALCLASSPATH="$i":$LOCALCLASSPATH
  fi
done

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
  JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
  LOCALCLASSPATH=`cygpath --path --windows "$LOCALCLASSPATH"`
fi

$JAVACMD -classpath "$LOCALCLASSPATH" de.hunsicker.jalopy.plugin.console.ConsolePlugin "$@"
