import haxe.Timer;
import sys.io.File;

class Main {
    static function increaseSleep(sleepSchedule:Map<Int, Array<Int>>, guard:Int, time:Int) {
        if (sleepSchedule[guard] != null) {
            sleepSchedule[guard][time] += 1;
        } else {
            sleepSchedule[guard] = [ for (x in 0...59) 0 ] ;
            sleepSchedule[guard][time] = 1;
        }
    }
    static function main() {

        var data = File.getContent("input").split('\n');
        //var data = File.getContent("input.sample").split('\n');
        data.remove("");

        var stamp = Timer.stamp();
        var currentGuard:Int = 0;
        var sleepSchedule = new Map<Int, Array<Int>>();
        var isSleeping:Bool = false;
        var prevTime = -1;

        for (sleeplog in data) {
            var splitLog = sleeplog.split(' ');
            var strTime = splitLog[1].substring(0, splitLog[1].length-1);
            var time = Std.parseInt(strTime.split(':')[1]);

            if (splitLog[2] == "Guard") {
                currentGuard = Std.parseInt(splitLog[3].substring(1, splitLog[3].length));
                isSleeping = false;
                prevTime = -1;
            } else if (splitLog[2] == "falls") {
                if (!isSleeping) {
                    prevTime = time;
                    isSleeping = true;
                }
            } else if (splitLog[2] == "wakes") {
                if (isSleeping) {
                    for (x in prevTime...time) {
                        increaseSleep(sleepSchedule, currentGuard, x);
                     }
                    isSleeping = false;
                }
            }
        }
        var guardOne = {
            "totalSlept": 0,
            "guard": 0,
            "time": 0,
            "days": 0
        }
        var guardTwo = {
            "time": 0,
            "amount": 0,
            "guard": 0
        }
        for (guard in sleepSchedule.keys()) {
            var max = 0;
            var time = 0;
            var totalSlept = 0;

            for (sleepTime in 0...59) {
                if (sleepSchedule[guard][sleepTime] > max) {
                    max  = sleepSchedule[guard][sleepTime];
                    time = sleepTime;
                }
                if (max > guardTwo.amount) {
                    guardTwo.time = sleepTime;
                    guardTwo.amount = max;
                    guardTwo.guard = guard;
                }
                totalSlept += sleepSchedule[guard][sleepTime];
            }

            if (totalSlept > guardOne.totalSlept) {
                guardOne.guard = guard;
                guardOne.time = time;
                guardOne.totalSlept = totalSlept;
                guardOne.days = max;
            }
        }
        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + guardOne.time * guardOne.guard);
        trace("Part 2 Result: " + guardTwo.time * guardTwo.guard);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
