function result = posIdx (P,CfreePoints)
    xid = find(round(CfreePoints(:,1),4) == round(P(1),4));
    yid = find(round(CfreePoints(:,2),4) == round(P(2),4));
    
    if (xid == yid)
        result = xid;
    else
        result = 0;
    end
end