from datetime import datetime

def serialize_doc(doc):
    data = doc.to_dict() or {}
    out = {"id": doc.id}
    for k, v in data.items():
        if hasattr(v, "ToDatetime"):
            try:
                out[k] = v.ToDatetime().isoformat()
            except Exception:
                out[k] = str(v)
        elif isinstance(v, datetime):
            out[k] = v.isoformat()
        else:
            out[k] = v
    return out
