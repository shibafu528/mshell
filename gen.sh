#!/bin/zsh

# remote_plugin_call plugin内のprotoディレクトリを指すようにする
MRPC_PROTO_ROOT=~/.mikutter-mrpc/plugin/remote_plugin_call/proto

# shell plugin内のprotoディレクトリを指すようにする
MSHELL_PROTO_ROOT=~/.mikutter-mrpc/plugin/shell/proto

# https://github.com/protocolbuffers/protobuf.git 内のsrcディレクトリを指すようにする
PROTOBUF_ROOT=~/git/protobuf/src

OUT=./generated

mkdir -p $OUT

protoc $MRPC_PROTO_ROOT/*.proto $MSHELL_PROTO_ROOT/*.proto \
       --proto_path=$MRPC_PROTO_ROOT/ \
       --proto_path=$MSHELL_PROTO_ROOT/ \
       --proto_path=$PROTOBUF_ROOT/ \
       --swift_opt=Visibility=Public \
       --swift_out=$OUT \
       --grpc-swift_opt=Visibility=Public \
       --grpc-swift_out=$OUT
