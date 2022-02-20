/*
   Pofwd -- A network port forwarding program
   Copyright (C) 2016 Star Brilliant <m13253@hotmail.com>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

func main() {
	confPath := "pofwd.conf"
	if len(os.Args) == 2 {
		if os.Args[1] == "--help" {
			printUsage()
			os.Exit(0)
		} else {
			confPath = os.Args[1]
		}
	} else if len(os.Args) == 5 {
		if err := startForwarding(os.Args[1], os.Args[2], os.Args[3], os.Args[4]); err != nil {
			log.Fatalln(err)
		}
		<-make(chan bool)
		os.Exit(0)
	} else if len(os.Args) != 1 {
		printUsage()
		os.Exit(1)
	}
	confFile, err := os.Open(confPath)
	if err != nil {
		log.Fatalln("cannot open configuration file:", err)
	}
	confScanner := bufio.NewScanner(confFile)
	confLineCount := 0
	for confScanner.Scan() {
		confLineCount++
		line := strings.SplitN(confScanner.Text(), "#", 2)[0]
		fields := strings.Fields(line)
		if len(fields) == 0 {
			continue
		} else if len(fields) != 4 {
			log.Fatalf("line %d: requires four parameters 'from protocol' 'from address' 'to protocol' 'to address'\n", confLineCount)
		} else if err = startForwarding(fields[0], fields[1], fields[2], fields[3]); err != nil {
			log.Fatalln(err)
		}
	}
	confFile.Close()
	if err = confScanner.Err(); err != nil {
		log.Fatalln("cannot read configuration file:", err)
	}
	<-make(chan bool)
}

func printUsage() {
	fmt.Printf("Usage: %s [CONFIG]\n   Or: %s <FROM PROTOCOL> <FROM ADDRESS> <TO PROTOCOL> <TO ADDRESS>\n\n  CONFIG\tConfiguration file [Default: pofwd.conf]\n\n", os.Args[0], os.Args[0])
}