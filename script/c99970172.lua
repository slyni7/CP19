--세상의 책이 전부 모이는 도서관
local m=99970172
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--발동
	YuL.Activate(c)
	
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	
	--서치 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_DECK,0)
	c:RegisterEffect(e2)

	--특수 소환 제약
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	
	--바벨의 도서관 장서목록에 접속
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)

end

--내성
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--특수 소환 제약
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_DECK+LOCATION_GRAVE)
end

--바벨의 도서관 장서목록에 접속
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local babel=YuL.random(99970174,99970200)
	local token=Duel.CreateToken(tp,babel)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end
