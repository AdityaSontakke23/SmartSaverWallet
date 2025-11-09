extension StringExtensions on String {

  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }


  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }


  String get initials {
    if (isEmpty) return '';
    final words = split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}

extension DoubleExtensions on double {

  String get toCurrency {
    return '\$${toStringAsFixed(2)}';
  }


  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

extension DateTimeExtensions on DateTime {

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }


  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && 
           month == yesterday.month && 
           day == yesterday.day;
  }


  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
