public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer
public import Memory_Allocator
public import Memory
public import Storage_Contiguous

public typealias Fixed<E: ~Copyable> =
    __Fixed<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded>
