// import 'package:dart_mappable/dart_mappable.dart';

// part 'message_content.mapper.dart';

// @MappableClass()
// class MessageContent with MessageContentMappable {
//   const MessageContent({
//     required this.letterhead,
//     required this.date,
//     required this.recipients,
//     this.salutation,
//     required this.body,
//     this.close,
//     required this.signature,
//     this.attachments,
//   });

//   final String letterhead;
//   final String date;
//   final String recipients;
//   final String? salutation;
//   final List<Paragraph> body;
//   final String? close;
//   final String signature;
//   final List<Attachment>? attachments;
// }

// @MappableEnum()
// enum ParagraphType { normal, heading, quote, ul, ol, invocation }

// @MappableClass()
// class Paragraph with ParagraphMappable {
//   const Paragraph({
//     this.type = ParagraphType.normal,
//     this.section,
//     required this.text,
//     this.reference,
//   });

//   final ParagraphType type;
//   final String? section;
//   final String text;
//   final String? reference;
// }

// @MappableClass()
// class Attachment with AttachmentMappable {
//   const Attachment({
//     required this.title,
//     this.date,
//     required this.paragraphs,
//   });

//   final String title;
//   final String? date;
//   final List<Paragraph> paragraphs;
// }
