pub fn DynamicArray(
    comptime T: type,
) type {
    return struct {
        data: [*]T,
        max_rows: usize,
        max_size: usize,
        const Self = @This();

        pub fn add(self: Self, row: usize, payload: T) void {
            var current: usize = 0;
            for (0..self.max_rows) |i| {
                var cols = &self.data[current];
                if (i == row) {
                    self.data[current] += 1;
                    current += @intCast(1 + cols.*);

                    DefaultAdd(T, self.data, self.max_size, current, payload);

                    return;
                } else {
                    current += @intCast(1 + cols.*);
                }
            }
        }

        pub fn getAtRow(self: Self, row: usize) []i32 {
            var current: usize = 0;
            for (0..self.max_rows) |i| {
                var cols = &self.data[current];
                if (i == row) {
                    var last = current;
                    current += @intCast(1 + cols.*);
                    var res = self.data[last..current];
                    return res;
                }
                current += @intCast(1 + cols.*);
            }

            return self.data[0..self.max_rows];

        }

        pub fn getNext(self: Self, iter: usize) ?i32 {
            var current: usize = 0;
            var j: usize = 0;

            for (0..self.max_rows) |_| {
                var size: usize = @intCast(self.data[current]);

                if (size > 0) {
                    var start: usize = current + 1;
                    var end: usize = start + size;

                    var row = self.data[start..end];

                    for (row, 0..) |_, i| {
                        if (j == iter) {
                            return row[i];
                        }
                        j += 1;
                    }
                }
                current += @intCast(1 + size);
            }

            return null;
        }

        pub fn init(data: [*]T, size: usize, rows: usize) Self {
            return Self{
                .data = @ptrCast(data),
                .max_size = size,
                .max_rows = rows,
            };
        }
    };
}

pub fn DefaultAdd(comptime t: type, list: [*]t, size: usize, pos: usize, x: t) void {
    var i: usize = size + 1;
    while (i >= pos) : (i -= 1) {
        list[i] = list[i - 1];
    }

    list[pos - 1] = x;
}
