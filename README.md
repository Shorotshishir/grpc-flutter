# flutter_grpc
This is an application that can receive `grpc` server stream and show it in the UI.

## Regenerate services from protofile
protoc --dart_out=grpc:lib/src/generated -Iprotos protos/greet.proto

## Test
To test the application , use the server application from this [repo](https://github.com/Shorotshishir/grpc/tree/main/Server)
> This application will be able to receive server side stream  
