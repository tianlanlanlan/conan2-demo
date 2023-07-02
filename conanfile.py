from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps
from conan.tools import CppInfo
from conan.tools.layout import basic_layout
from conan.tools.files import copy
import os


class Conan2Demo(ConanFile):
    name = "conan2_demo"
    version = "0.1.0"
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "platform": ["linux", "riscv", "arm"]
    }
    default_options = {
        "platform": "linux"
    }

    def build_requirements(self):
        self.tool_requires("cmake/3.24.4")

    def requirements(self):
        self.requires("zlib/1.2.13")
        self.requires("fmt/9.1.0")
        self.requires("protobuf/3.21.9")
        self.requires("nlohmann_json/3.11.2")

    def generate(self):
        tc = CMakeToolchain(self)
        # tc.user_presets_path = False
        if not tc.user_presets_path == False:
            tc.presets_prefix = self.options.platform
        tc.generate()

        deps = CMakeDeps(self)
        deps.configuration = "Release"
        deps.generate()
        deps.configuration = "Debug"
        deps.generate()
        deps.configuration = "RelWithDebInfo"
        deps.generate()
        # deps.configuration = "MinSizeRel"
        # deps.generate()

        self.print_dependencies()
        dst_dir = f"{self.build_folder}/bin"
        for dep in self.dependencies.values():
            try:
                src_dir = dep.cpp_info.libdirs[0]
            except:
                continue
            copy(self, "*.so.*", src_dir, dst_dir)

    def layout(self):
        self.folders.generators = "conan"

    def print_dependencies(self):
        for require, dependency in self.dependencies.items():
            direct = require.direct
            ref = str(dependency.ref)
            try:
                build_type = str(dependency.settings.build_type)
            except:
                build_type = "None"
            cpp_libs = str(dependency.cpp_info.libs)
            libs = [component.libs for component_name,
                    component in dependency.cpp_info.components.items()]
            self.output.info(
                f"Dependency is direct={direct}: {ref:20} {build_type:10} {cpp_libs:10} {libs}"
            )
