--액션필드!
function c99880000.initial_effect(c)
	c:SetUniqueOnField(1,0,99880000)
	--activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e7)
	--개시시 발동	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(c99880000.op)
	c:RegisterEffect(e1)
	--필드에서 뻐기기
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c99880000.reptg)
	c:RegisterEffect(e3)
	--대상 내성
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e11=e6:Clone()
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e11)
	--액션매직!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c99880000.ntcon)
	e2:SetOperation(c99880000.efop)
	c:RegisterEffect(e2)
end
--액션 1장만
function c99880000.cfilter(c)
	return c:IsSetCard(0xac1)
end
function c99880000.ntcon(e,c)
	local p=Duel.GetTurnPlayer()
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(c99880000.cfilter,p,LOCATION_HAND,0,1,nil)
end
--
function c99880000.efop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local val=YuL.random(1,22)
	local token=22
	if val==1 then
		token=Duel.CreateToken(p,95000044)
	elseif val==2 then
		token=Duel.CreateToken(p,95000046)
	elseif val==3 then
		token=Duel.CreateToken(p,95000047)
	elseif val==4 then
		token=Duel.CreateToken(p,95000048)
	elseif val==5 then
		token=Duel.CreateToken(p,95000051)	
	elseif val==6 then
		token=Duel.CreateToken(p,95000065)
	elseif val==7 then
		token=Duel.CreateToken(p,95000066)
	elseif val==8 then
		token=Duel.CreateToken(p,95000067)	
	elseif val==9 then
		token=Duel.CreateToken(p,95000068)	
	elseif val==11 then
		token=Duel.CreateToken(p,95000095)
	elseif val==12 then
		token=Duel.CreateToken(p,95000099)	
	elseif val==13 then
		token=Duel.CreateToken(p,95000111)
	elseif val==14 then
		token=Duel.CreateToken(p,95000112)			
	elseif val==15 then
		token=Duel.CreateToken(p,95000114)
	elseif val==16 then
		token=Duel.CreateToken(p,95000119)
	elseif val==17 then
		token=Duel.CreateToken(p,95000123)
	elseif val==18 then
		token=Duel.CreateToken(p,95000136)
	elseif val==19 then
		token=Duel.CreateToken(p,95000137)
	elseif val==20 then
		token=Duel.CreateToken(p,95000145)
	elseif val==21 then
		token=Duel.CreateToken(p,95000148)
	elseif val==10 then
		token=Duel.CreateToken(p,95000157)	
	end
	if val~=22 then
		token:SetCardData(CARDDATA_TYPE,Duel.ReadCard(token,CARDDATA_TYPE)-TYPE_TOKEN)
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-p,token)
	end
end

function c99880000.afilter(c)
	return c:GetCode()~=99880000
end
function c99880000.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if c:GetPreviousLocation()&LOCATION_HAND>0 then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c99880000.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
	 return rp~=3
  end
  return true
end
