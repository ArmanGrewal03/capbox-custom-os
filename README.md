# capbox

**capbox** is a minimal, educational **capability-based microkernel** focused on **security, isolation, and fun**.  
The goal of this project is to explore how modern secure operating systems work by building a small microkernel where **processes only have the permissions (capabilities) explicitly given to them**.

This is **not** a full-featured OS. It is intentionally small, readable, and demonstrable.

---

## 🎯 Project Goals

- Learn low-level OS development (booting, memory, interrupts)
- Implement a **capability-based security model**
- Enforce **strong isolation** between user programs
- Keep the system **simple, auditable, and fun**
- Run sandboxed user programs (e.g. small games or test apps)

---

## 🔐 Core Security Idea

There are **no global permissions**.

A program can only:
- access memory
- write to the screen
- communicate with other programs

**if and only if** it owns a valid **capability** issued by the kernel.

No capability = no power.

---

## 🧠 High-Level Design

- **Microkernel**
  - Minimal kernel responsibilities
  - Process/thread management
  - Virtual memory
  - IPC (message passing)
  - Capability enforcement

- **User Space**
  - Sandboxed programs
  - No direct hardware access
  - Interaction only via syscalls + capabilities

---

## 🛠️ Planned Architecture

- Architecture: `x86_64`
- Bootloader: `GRUB (Multiboot2)`
- Language: `C` (with small amounts of assembly)
- Emulator: `QEMU`
- Debugging: `GDB`

---

## 🚀 Implementation Roadmap (Reference)

### Phase 1: Boot & Basics
1. Boot kernel using GRUB
2. Basic screen output
3. Print `kernel ok`

---

### Phase 2: Interrupts & Timing
4. Set up IDT
5. Timer interrupt
6. Simple tick counter

---

### Phase 3: Memory Management
7. Enable paging
8. Higher-half kernel (optional but recommended)
9. Physical frame allocator
10. Simple kernel heap

---

### Phase 4: Scheduling & Execution
11. Kernel threads
12. Context switching
13. Round-robin scheduler
14. Run multiple kernel tasks

---

### Phase 5: User Mode
15. Enter user mode (ring 3)
16. System call mechanism
17. Minimal syscall table
18. User program prints to screen via syscall

---

## 🔑 Capability System

### Capability Model
Each process has a **capability table (C-space)**:
cap_id -> { object, type, rights }

User programs only see `cap_id` (an integer handle).

The kernel verifies:
- capability exists
- object type matches
- requested operation is allowed

---

### Initial Capability Objects
- **Console** (write-only)
- **Endpoint** (IPC)
- **Memory region**
- **Process / thread control**

---

### Rights Examples
- `READ`
- `WRITE`
- `SEND`
- `RECV`
- `MAP`
- `GRANT`
- `KILL`

---

## 📬 IPC (Inter-Process Communication)

- Communication happens via **endpoints**
- Message passing only
- Kernel copies and validates messages
- No shared memory by default

### Minimal IPC Syscalls
1. `cap_send(endpoint, buffer, length)`
2. `cap_recv(endpoint, buffer, length)`
3. `cap_yield()`
4. `cap_exit(code)`

(Additional syscalls added later if needed)

---

## 🎮 Demo Programs

### Program A: Game / Normal App
- Has console capability
- Can print and receive input
- Runs normally

### Program B: Cheater / Test App
- Missing required capabilities
- Attempts forbidden actions
- Kernel safely denies access

This demonstrates **real isolation and security enforcement**.

---

## ❌ Non-Goals (Important)

- No full POSIX support
- No complex filesystem (early versions)
- No networking
- No GUI at first
- No formal verification

The focus is **clarity and correctness**, not feature count.

---

## 🏁 End Goal

A small, understandable OS that can clearly demonstrate:

- Capability-based security
- Process isolation
- Safe failure of misbehaving programs
- Clean microkernel design

---

## 📌 Status

🚧 Work in progress  
Built for learning, experimentation, and fun.

---

## 📖 Inspiration

- seL4
- KeyKOS / EROS
- Zircon (Fuchsia)
- OSDev community

---

> capbox — a minimal capability-based microkernel for sandboxed applications.

