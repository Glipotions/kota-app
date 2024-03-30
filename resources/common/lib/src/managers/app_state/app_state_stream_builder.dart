import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// A widget that simplifies the handling of streams throughout
/// the app with a desired data type.
class MaterialRxStreamBuilder<T> extends StatefulWidget {
  /// Creates a [MaterialRxStreamBuilder] to handle streams in the app.
  ///
  /// The [stream] is the source stream of data.
  /// The [builder] is a callback that creates widgets based 
  /// on the latest data from the [stream].
  /// The [initialData] is the initial data to be used before
  ///  the first event from the [stream].
  /// The [valuesSnapshotIndex] is used when working with ReplayStream,
  ///  specifying the snapshot index.
  const MaterialRxStreamBuilder({
    required this.stream,
    required this.builder,
    this.initialData,
    this.valuesSnapshotIndex,
    super.key,
  });

  /// The stream of data with a generic type [T].
  final Stream<T> stream;

  /// A callback that creates widgets based on 
  /// the latest data from the [stream].
  final AsyncWidgetBuilder<T> builder;

  /// The initial data to be used before the first event from the [stream].
  final T? initialData;

  /// The index to retrieve a snapshot when working with ReplayStream.
  final int? valuesSnapshotIndex;

  @override
  State<StatefulWidget> createState() => _MaterialRxStreamBuilderState<T>();
}

class _MaterialRxStreamBuilderState<T>
    extends State<MaterialRxStreamBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    final initialData = _getInitialData(widget.stream);

    return StreamBuilder(
      initialData: initialData,
      stream: widget.stream,
      builder: widget.builder,
    );
  }

  /// Retrieves the initial data to be used before 
  /// the first event from the [stream].
  T? _getInitialData(Stream<T> stream) {
    T? initialData;
    if (widget.initialData != null) {
      initialData = widget.initialData;
    } else if (stream is ValueStream<T> && stream.hasValue) {
      initialData = stream.value;
    } else if (stream is ReplayStream<T>) {
      if (widget.valuesSnapshotIndex != null &&
          stream.values.length >= widget.valuesSnapshotIndex!) {
        initialData = stream.values.elementAt(widget.valuesSnapshotIndex!);
      } else if (stream.values.isNotEmpty) {
        initialData = stream.values.last;
      }
    }

    return initialData;
  }
}
