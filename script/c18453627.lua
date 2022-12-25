--계절의 구성요소: 새하얀 상쾌함
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritfilter,extrafil=s.extragroup,
		extraop=s.extraop,matfilter=s.matfilter,location=LSTN("HDG"),forcedselection=s.ritcheck,specificmatfilter=s.specificfilter,extratg=s.extratg})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCL(1,id)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.ritfilter(c)
	return c:IsSetCard("계절")
end
function s.extragroup(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GMGroup(Card.IsAbleToGrave,tp,"D",0,nil)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:IsLoc("G") then
		local eset={Duel.IsPlayerAffectedByEffect(tp,18453633)}
		local te=eset[1]
		te:UseCountLimit(tp,1,true)
	end
	local dg=mat:Filter(Card.IsLoc,nil,"D")
	local mg=mat:Clone()
	mg:Sub(dg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"HD")
end
function s.specificfilter(c,rc,mg,tp)
	return not c:IsLoc("D") or (not rc:IsLoc("D") and c:IsAttribute(rc:GetAttribute()))
end
function s.matfilter2(c,att)
	return c:IsLoc("D") and c:IsAttribute(att)
end
function s.matfilter(c,e,tp)
	return true
end
function s.ritcheck(e,tp,g,sc)
	return (sc:IsLoc("HD") or (e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsPlayerAffectedByEffect(tp,18453633)))
		and ((not sc:IsLoc("D") and g:FilterCount(s.matfilter2,nil,sc:GetAttribute())<=1
		and g:FilterCount(Card.IsLoc,nil,"D")<=1)
		or (g:FilterCount(Card.IsLoc,nil,"D")==0
			and (not sc:IsLoc("D") or g:IsExists(Card.IsAttribute,1,nil,sc:GetAttribute())))),false
end
function s.cfil2(c)
	return c:IsSetCard("계절") and c:IsAbleToDeckAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"G",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.cfil2,tp,"G",0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end