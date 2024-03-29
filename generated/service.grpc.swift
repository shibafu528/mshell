//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: service.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate `Mrpc_PluggaloidServiceClient`, then call methods of this protocol to make API calls.
public protocol Mrpc_PluggaloidServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Mrpc_PluggaloidServiceClientInterceptorFactoryProtocol? { get }

  func query(
    _ request: Mrpc_ProxyQuery,
    callOptions: CallOptions?
  ) -> UnaryCall<Mrpc_ProxyQuery, Mrpc_ProxyValue>

  func subscribe(
    _ request: Mrpc_SubscribeRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mrpc_Event) -> Void
  ) -> ServerStreamingCall<Mrpc_SubscribeRequest, Mrpc_Event>

  func filtering(
    callOptions: CallOptions?,
    handler: @escaping (Mrpc_FilteringRequest) -> Void
  ) -> BidirectionalStreamingCall<Mrpc_FilteringPayload, Mrpc_FilteringRequest>

  func spell(
    callOptions: CallOptions?,
    handler: @escaping (Mrpc_SpellResponse) -> Void
  ) -> BidirectionalStreamingCall<Mrpc_SpellRequest, Mrpc_SpellResponse>
}

extension Mrpc_PluggaloidServiceClientProtocol {
  public var serviceName: String {
    return "mrpc.PluggaloidService"
  }

  /// Unary call to Query
  ///
  /// - Parameters:
  ///   - request: Request to send to Query.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func query(
    _ request: Mrpc_ProxyQuery,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mrpc_ProxyQuery, Mrpc_ProxyValue> {
    return self.makeUnaryCall(
      path: "/mrpc.PluggaloidService/Query",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeQueryInterceptors() ?? []
    )
  }

  /// Server streaming call to Subscribe
  ///
  /// - Parameters:
  ///   - request: Request to send to Subscribe.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  public func subscribe(
    _ request: Mrpc_SubscribeRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mrpc_Event) -> Void
  ) -> ServerStreamingCall<Mrpc_SubscribeRequest, Mrpc_Event> {
    return self.makeServerStreamingCall(
      path: "/mrpc.PluggaloidService/Subscribe",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeInterceptors() ?? [],
      handler: handler
    )
  }

  /// Bidirectional streaming call to Filtering
  ///
  /// Callers should use the `send` method on the returned object to send messages
  /// to the server. The caller should send an `.end` after the final message has been sent.
  ///
  /// - Parameters:
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ClientStreamingCall` with futures for the metadata and status.
  public func filtering(
    callOptions: CallOptions? = nil,
    handler: @escaping (Mrpc_FilteringRequest) -> Void
  ) -> BidirectionalStreamingCall<Mrpc_FilteringPayload, Mrpc_FilteringRequest> {
    return self.makeBidirectionalStreamingCall(
      path: "/mrpc.PluggaloidService/Filtering",
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeFilteringInterceptors() ?? [],
      handler: handler
    )
  }

  ///*
  /// サーバ上でspellを呼び出し、結果を要求する。
  /// サーバがSpellのパラメータのProxyを解決するために、クライアントにProxyQueryを送ることができる。クライアントはこのクエリに応答しなければならない。
  ///
  /// Callers should use the `send` method on the returned object to send messages
  /// to the server. The caller should send an `.end` after the final message has been sent.
  ///
  /// - Parameters:
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ClientStreamingCall` with futures for the metadata and status.
  public func spell(
    callOptions: CallOptions? = nil,
    handler: @escaping (Mrpc_SpellResponse) -> Void
  ) -> BidirectionalStreamingCall<Mrpc_SpellRequest, Mrpc_SpellResponse> {
    return self.makeBidirectionalStreamingCall(
      path: "/mrpc.PluggaloidService/Spell",
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSpellInterceptors() ?? [],
      handler: handler
    )
  }
}

public protocol Mrpc_PluggaloidServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'query'.
  func makeQueryInterceptors() -> [ClientInterceptor<Mrpc_ProxyQuery, Mrpc_ProxyValue>]

  /// - Returns: Interceptors to use when invoking 'subscribe'.
  func makeSubscribeInterceptors() -> [ClientInterceptor<Mrpc_SubscribeRequest, Mrpc_Event>]

  /// - Returns: Interceptors to use when invoking 'filtering'.
  func makeFilteringInterceptors() -> [ClientInterceptor<Mrpc_FilteringPayload, Mrpc_FilteringRequest>]

  /// - Returns: Interceptors to use when invoking 'spell'.
  func makeSpellInterceptors() -> [ClientInterceptor<Mrpc_SpellRequest, Mrpc_SpellResponse>]
}

public final class Mrpc_PluggaloidServiceClient: Mrpc_PluggaloidServiceClientProtocol {
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Mrpc_PluggaloidServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the mrpc.PluggaloidService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Mrpc_PluggaloidServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// To build a server, implement a class that conforms to this protocol.
public protocol Mrpc_PluggaloidServiceProvider: CallHandlerProvider {
  var interceptors: Mrpc_PluggaloidServiceServerInterceptorFactoryProtocol? { get }

  func query(request: Mrpc_ProxyQuery, context: StatusOnlyCallContext) -> EventLoopFuture<Mrpc_ProxyValue>

  func subscribe(request: Mrpc_SubscribeRequest, context: StreamingResponseCallContext<Mrpc_Event>) -> EventLoopFuture<GRPCStatus>

  func filtering(context: StreamingResponseCallContext<Mrpc_FilteringRequest>) -> EventLoopFuture<(StreamEvent<Mrpc_FilteringPayload>) -> Void>

  ///*
  /// サーバ上でspellを呼び出し、結果を要求する。
  /// サーバがSpellのパラメータのProxyを解決するために、クライアントにProxyQueryを送ることができる。クライアントはこのクエリに応答しなければならない。
  func spell(context: StreamingResponseCallContext<Mrpc_SpellResponse>) -> EventLoopFuture<(StreamEvent<Mrpc_SpellRequest>) -> Void>
}

extension Mrpc_PluggaloidServiceProvider {
  public var serviceName: Substring { return "mrpc.PluggaloidService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Query":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mrpc_ProxyQuery>(),
        responseSerializer: ProtobufSerializer<Mrpc_ProxyValue>(),
        interceptors: self.interceptors?.makeQueryInterceptors() ?? [],
        userFunction: self.query(request:context:)
      )

    case "Subscribe":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mrpc_SubscribeRequest>(),
        responseSerializer: ProtobufSerializer<Mrpc_Event>(),
        interceptors: self.interceptors?.makeSubscribeInterceptors() ?? [],
        userFunction: self.subscribe(request:context:)
      )

    case "Filtering":
      return BidirectionalStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mrpc_FilteringPayload>(),
        responseSerializer: ProtobufSerializer<Mrpc_FilteringRequest>(),
        interceptors: self.interceptors?.makeFilteringInterceptors() ?? [],
        observerFactory: self.filtering(context:)
      )

    case "Spell":
      return BidirectionalStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mrpc_SpellRequest>(),
        responseSerializer: ProtobufSerializer<Mrpc_SpellResponse>(),
        interceptors: self.interceptors?.makeSpellInterceptors() ?? [],
        observerFactory: self.spell(context:)
      )

    default:
      return nil
    }
  }
}

public protocol Mrpc_PluggaloidServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'query'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeQueryInterceptors() -> [ServerInterceptor<Mrpc_ProxyQuery, Mrpc_ProxyValue>]

  /// - Returns: Interceptors to use when handling 'subscribe'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeInterceptors() -> [ServerInterceptor<Mrpc_SubscribeRequest, Mrpc_Event>]

  /// - Returns: Interceptors to use when handling 'filtering'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeFilteringInterceptors() -> [ServerInterceptor<Mrpc_FilteringPayload, Mrpc_FilteringRequest>]

  /// - Returns: Interceptors to use when handling 'spell'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSpellInterceptors() -> [ServerInterceptor<Mrpc_SpellRequest, Mrpc_SpellResponse>]
}
