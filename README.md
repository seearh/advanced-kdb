## Advanced KDB CMTP
This repository contains an individual submission for an internal Capital Market Training Programme (CMTP) module. Code written here is for training purposes only, and are not designed for production use.

## Components
Tickerplant Processes
1. tick.q
Tickerplant that runs a subscriber-publisher network for data
2. tick/r.q
Real-time databases that selectively subscribes to the tickerplant for data within the day. Its trade table can be queried via the websockets.html webpage through kdb's Web Socket interface.
3. tick/ssl.q
Mock feedhandler that publishes randomly generated data, according to the tickerplant schema, to the tickerplant.
4. tick/cep.q
Complex event processor that subscribes to the tickerplant, aggregate some data, then publish it back to the tickerplant.

The components can be started through startup.sh.

## Debugging
The Debug/ folder contains:
1. db.zip
Problematic splayed tables.
2. tplog
Problematic tickerplant log file.
3. fixSplayedTab.q
Script that verbosely fixes the splayed table and enable them to be queried.
4. fixtplog.q
Script that verbosely fixes the tickerplant log file.
5. improveQueryPerformance.q
Script that seek to optimise an operation to cast a mixed type vector into dates. Performance is benchmarked against the given code.

## API
- embedPy and Java API were used to read in a CSV file (test_files/TRADES.csv) and publishes the contents to the tickerplant.
- A HTML interface for querying trades table from a running real-time database component, with filtering capabilities.
