package codes.dbg;

import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.infra.Blackhole;
import org.openjdk.jmh.runner.RunnerException;

import java.io.IOException;
import java.util.Random;

@State(Scope.Benchmark)
public class IteratingBenchmark {
    //    @Param({"100000000"}) // 100M
    @Param({"10000000"}) // 10M
    public static int ELEMENTS;

    public static void main(String[] args) throws IOException, RunnerException {
        org.openjdk.jmh.Main.main(args);
    }

    @Benchmark
    public static void cStyleForLoop(Blackhole bh, MockData data) {
        long sum = 0;

        for (int i = 0; i < data.randomInts.length; i++) {
            sum += data.randomInts[i];
        }

        bh.consume(sum);
    }

    @State(Scope.Thread)
    public static class MockData {
        private int[] randomInts = new int[ELEMENTS];

        @Setup(Level.Trial)
        public void setup() {
            Random r = new Random();
//            this.randomInts = Stream.iterate(r.nextInt(), i -> i + r.nextInt(1022) + 1).mapToInt(Integer::intValue).limit(ELEMENTS).toArray();
            this.randomInts = r.ints(ELEMENTS).toArray();
        }
    }
}
