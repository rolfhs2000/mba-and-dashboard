import unicodedata
import re

mapping_text_dict = {
    'fb': 'Facebook',
    'facebook': 'Facebook'
}

def clean_text_field(text, convention=None):
    """
    Clean text field by removing leading/trailing spaces, chuẩn hóa unicode và chuyển đổi theo convention.
    """
    if isinstance(text, str):
        # Chuẩn hóa unicode
        text = unicodedata.normalize('NFC', text)
        if convention == 'title':
            text = text.strip().title()
        elif convention == 'capitalize':
            text = text.strip().capitalize()
        else:
            text = text.strip()
    else:
        text = 'error'  # Xử lý nghiệp vụ sau
    return text

def is_valid_email(email):
    """Kiểm tra email có hợp lệ hay không."""
    if not isinstance(email, str):
        return False
    pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    return re.match(pattern, email) is not None

def handle_invalid_email(email):
    """Kiểm tra tính hợp lệ của email. Nếu email không hợp lệ, trả về 'error' => Xử lý nghiệp vụ sau."""
    if is_valid_email(email):
        return email
    return 'error'

def mapping_text(text, _mapping_text_dict, remove_special_tail=None, convention=None):
    """ Clean text, replace pattern, mapping value according to business rules. """
    if not isinstance(text, str): # Check if text is not string
        return 'error'
    else:
        if remove_special_tail != None: # Remove special tail if specified
            text = re.sub('--', 'unknown', text) # Replace '--' -> 'unknown' according to business rules.
            pattern=rf'{remove_special_tail}+$'
            text = re.sub(pattern, '', text)
        text = _mapping_text_dict.get(text.lower(), text)
        if convention == 'lower': # Convert to lower case if specified
            return text.lower()
        else:
            return text