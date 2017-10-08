var result = rs.initiate({
  _id: "testrs",
  members: [
    {
      _id: 0,
      host: "mongo1",
      tags: {
        type: 'data',
      },
    },
    {
      _id: 1,
      host: "mongo2",
      tags: {
        type: 'data',
      },
    },
    {
      _id: 2,
      host: "mongo3",
      tags: {
        type: 'data',
      },
    },
    {
      _id: 3,
      host: "mongo4",
      slaveDelay: 10 * 60, // 10min of delay
      priority: 0,
      hidden: true, 
      tags: {
        type: 'delayed',
      },
    },
    {
      _id: 4,
      host: "mongo5",
      slaveDelay: 10 * 60, // 10min of delay
      priority: 0,
      hidden: true, 
      tags: {
        type: 'delayed',
      },
    }
  ]
});

print("Replica set configuration result:");
printjson(result);
