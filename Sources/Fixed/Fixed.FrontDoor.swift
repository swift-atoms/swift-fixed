public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Memory_Allocator_Primitive
public import Memory_Heap
public import Storage_Contiguous

public typealias Fixed<E: ~Copyable> =
    __Fixed<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Bounded>
