/**
 * Created by andrew.crowell on 5/22/14.
 */
var AWS = require('aws-sdk');

AWS.config.update({accessKeyId:"AKIAIAY5VX3FK55SWSGA", secretAccessKey:"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"});
var s3 = new AWS.S3();

function deleteBucket(bucket) {
  console.log('Deleting bucket: ' + bucket);
  s3.deleteBucket({Bucket:bucket}, function(err, res) {
    if (err) {
      console.log(err);
    } else {
      console.log("Deleted bucket: " + bucket);
    }
  });
}

function clearBucket(bucket, callback) {
  s3.listObjects({Bucket:bucket}, function(err, res) {
    if (err) {
      console.log(err);
    } else {
      var params = {'Delete':{'Objects':[]}, 'Bucket':bucket};
      if (res.Contents.length > 0) {
        for (var i=0; i<res.Contents.length; i++) {
          params.Delete.Objects.push({'Key':res.Contents[i].Key});
        }

        console.log('Deleting objects in bucket:' + bucket);
        s3.deleteObjects(params, function(err, res) {
          if (err) {
            console.log(err);
          } else {
            callback(bucket);
          }
        });
      } else {
        // the bucket is empty, nothing to do
        callback(bucket);
      }
    }
  });
}

s3.listBuckets({}, function(err, res) {
  console.log(res);
  for (var i=0; i<res.Buckets.length; i++) {
    if (res.Buckets[i].Name.indexOf('image-bucket-') === 0) {
      clearBucket(res.Buckets[i].Name, deleteBucket);
    }
  }
});
