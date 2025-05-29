#include <iostream>
#include "load-spz.h"
#include "splat-types.h"

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cerr << "Usage: spzcli <input.ply> <output.spz>" << std::endl;
        return 1;
    }

    std::string inputPly = argv[1];
    std::string outputSpz = argv[2];

    spz::UnpackOptions unpackOptions;
    spz::GaussianCloud cloud = spz::loadSplatFromPly(inputPly, unpackOptions);

    spz::PackOptions packOptions;
    if (!spz::saveSpz(cloud, packOptions, outputSpz)) {
        std::cerr << "Failed to save SPZ to: " << outputSpz << std::endl;
        return 1;
    }

    std::cout << "Converted " << inputPly << " to " << outputSpz << std::endl;

    return 0;
}