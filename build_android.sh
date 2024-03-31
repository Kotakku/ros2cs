#!/bin/bash

display_usage() {
    echo "Usage: "
    echo "source build_android.sh -p <path-to-android-NDK>"
}

if [ -z "${ROS_DISTRO}" ]; then
    echo "Source your ros2 distro first (foxy, galactic, humble or rolling are supported)"
    exit 1
fi

TESTS=0
MSG="Build started."
STANDALONE=ON

ANDROID_NDK=""

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -p|--ndk-path)
      ANDROID_NDK="$2"
      shift # past argument
      shift # past argument
      ;;
    -s|--standalone)
      STANDALONE=ON
      MSG="$MSG (standalone)"
      shift # past argument
      ;;
    -h|--help)
      display_usage
      exit 0
      shift # past argument
      ;;
    *)    # unknown option
      display_usage
      exit 0
      ;;
  esac
done

echo $MSG

ANDROID_ABI=arm64-v8a
ANDROID_NATIVE_API_LEVEL=28
ANDROID_TOOLCHAIN_NAME=aarch64-linux-android-clang

PKG_AMENT_LINT=$(echo ament_{lint_common,lint_auto,lint_cmake,flake8,pep257,copyright})
PKG_TF2="tf2 examples_tf2_py test_tf2 $(echo tf2_{ros,eigen_kdl,kdl,bullet,py,eigen,tools,geometry_msgs,sensor_msgs,ros_py})"
PKG_TESTS="test_rmw_implementation test_tracetools test_tracetools_launch"
PKG_IGNORE="${PKG_AMENT_LINT} ${PKG_TF2} ${PKG_TESTS}"
PKG_ROS2CS="ros2cs_core ros2cs_common ros2cs_tests ros2cs_examples rosidl_generator_cs"

ROS2CS_CMAKE_ARGS="-DCMAKE_BUILD_TYPE=Release \
-DFOONATHAN_MEMORY_FORCE_VENDORED_BUILD=ON \
-DTRACETOOLS_DISABLED=ON \
-DTRACETOOLS_STATUS_CHECKING_TOOL=OFF \
-DRCL_COMMAND_LINE_ENABLED=OFF \
-DRCL_LOGGING_ENABLED=OFF \
-DSTANDALONE_BUILD=${STANDALONE} \
-DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
-DCMAKE_ANDROID_NDK=${ANDROID_NDK} \
-DANDROID_NDK=${ANDROID_NDK} \
-DCMAKE_ANDROID_ARCH_ABI=${ANDROID_ABI} \
-DANDROID_ABI=${ANDROID_ABI} \
-DANDROID_PLATFORM=android-${ANDROID_NATIVE_API_LEVEL} \
-DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
-DTHIRDPARTY=ON \
-DTHIRDPARTY_TinyXML2=FORCE \
-DTHIRDPARTY_Asio=FORCE \
-DCOMPILE_EXAMPLES=OFF \
-DBUILD_TESTING=OFF \
-DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,'\$ORIGIN',-rpath=.,--disable-new-dtags" \
-DCMAKE_FIND_ROOT_PATH=${PWD}/install/ \
--no-warn-unused-cli \
-Wno-deprecated \
-Wno-pointer-bool-conversion"

colcon build \
--event-handlers console_stderr+ \
--packages-ignore ${PKG_IGNORE} \
--merge-install \
--cmake-clean-cache \
--cmake-args ${ROS2CS_CMAKE_ARGS}