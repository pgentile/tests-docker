for (var i = 0; i < 500000; i++) {
    db.samples.insert({
        index: i,
        name: "Document with index " + i,
        creationDate: new Date(),
    });
}
