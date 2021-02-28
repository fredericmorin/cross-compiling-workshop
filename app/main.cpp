#include <pcap/pcap.h>

#include <chrono>
#include <getopt.h>
#include <iomanip>
#include <iostream>
#include <sstream>

void printHelp(const std::string& progname)
{
    std::cerr << "Usage: " << progname << " <pcapfile>" << std::endl;
    std::cerr << std::left << std::setw(14) << " pcapfile" << "pcap capture file" << std::endl;
}

std::chrono::system_clock::time_point fromTimeval(const struct timeval& timeval_)
{
    return std::chrono::system_clock::time_point(std::chrono::seconds(timeval_.tv_sec) + std::chrono::microseconds(timeval_.tv_usec));
}

constexpr double toSeconds(const std::chrono::system_clock::duration duration)
{
    return std::chrono::duration_cast<std::chrono::duration<double, std::ratio<1>>>(duration).count();
}

int main(int argc, char **argv) {
    std::string pcapFile;

    ///////////////////////////////////
    // parse

    int c;
    auto progname = "app";

    static struct option longOptions[] = {
            {"help",     required_argument, 0, 'h'},
            {0, 0,                          0, 0}
    };
    while (EOF != (c = getopt_long(argc, argv, "h", longOptions, NULL)))
    {
        switch (c)
        {
            case '?':
            case 'h':
                printHelp(progname);
                return 2;

            default:
                std::cerr << "?? getopt returned character code " << int(c) << " ??" << std::endl;
        }
    }

    if (optind >= argc)
    {
        std::cerr << "error: pcapfile option is required" << std::endl << std::endl;
        printHelp(progname);
        return 3;
    }

    pcapFile = argv[optind++];

    ///////////////////////////////////
    // init

    // open pcap
    pcap_t* pcap;
    char errbuf[PCAP_ERRBUF_SIZE];
    if ((pcap = pcap_open_offline(pcapFile.c_str(), errbuf)) == nullptr)
    {
        std::cerr << "error: opening pcap: " << std::string(errbuf) << std::endl;
        return 1;
    }

    ///////////////////////////////////
    // run

    // scroll through all the packets, count packets and determine start/end time
    struct pcap_pkthdr* header;
    const u_char* packet;
    bool first = true;
    std::chrono::system_clock::time_point from, to;
    int64_t count = 0;
    while (pcap_next_ex(pcap, &header, &packet) >= 0)
    {
        count++;
        const auto ts = fromTimeval(header->ts);
        if (first)
        {
            first = false;
            from = ts;
        }
        to = ts;
    }

    // status report
    std::stringstream ss;
    ss << "Pcap file " << pcapFile
       << " has " << count << " packets";
    if (count > 0)
    {
        ss << " over " << std::fixed << std::setprecision(3) << toSeconds(to - from) << "s";
    }
    std::cout << ss.str() << std::endl;

    // close
    pcap_close(pcap);

    return 0;
}
