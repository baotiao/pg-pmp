# pg-pmp

PostgreSQL poorman profile tool just like mysql poorman profile tool

### Usage

When running with sysbench to PostgreSQL, how to find the bottleneck?

```
└─[$] sh pg-pmp.sh
      5 do_futex_wait.constprop,__new_sem_wait_slow.constprop.0,PGSemaphoreLock,LWLockAcquireOrWait,XLogFlush,CommitTransaction,CommitTransactionCommandInternal,CommitTransactionCommand,exec_simple_query,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      4 epoll_wait,WaitEventSetWait,secure_read,pq_recvbuf,pq_getbyte,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      2 sem_post@@GLIBC_2.2.5,PGSemaphoreUnlock,LWLockRelease,XLogFlush,CommitTransaction,CommitTransactionCommandInternal,CommitTransactionCommand,exec_simple_query,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      2 recv,secure_read,pq_recvbuf,pq_getbyte,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      1 send,secure_write,internal_flush_buffer,socket_flush,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      1 index_open,ExecOpenIndices,ExecInsert,ExecModifyTable,standard_ExecutorRun,ProcessQuery,PortalRunMulti,PortalRun,exec_simple_query,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,WaitLatch,WalWriterMain,postmaster_child_launch,StartChildProcess,ServerLoop.isra.0,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,WaitLatch,CheckpointWriteDelay,BufferSync,CheckPointGuts,CreateCheckPoint,CheckpointerMain,postmaster_child_launch,StartChildProcess,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,WaitLatch,BackgroundWriterMain,postmaster_child_launch,StartChildProcess,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,WaitLatch,AutoVacLauncherMain,postmaster_child_launch,StartChildProcess,ServerLoop.isra.0,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,WaitLatch,ApplyLauncherMain,BackgroundWorkerMain,postmaster_child_launch,maybe_start_bgworkers,ServerLoop.isra.0,PostmasterMain,main
      1 epoll_wait,WaitEventSetWait,ServerLoop.isra.0,PostmasterMain,main
      1 btinsert,ExecInsertIndexTuples,ExecInsert,ExecModifyTable,standard_ExecutorRun,ProcessQuery,PortalRunMulti,PortalRun,exec_simple_query,PostgresMain,BackendMain,postmaster_child_launch,ServerLoop.isra.0,PostmasterMain,main
```

From the result, The bottleneck is the wal writing, This also meets our expectations.
