
** A list of Fantom visibilities.
enum class PlasticVisibility {
	** Private scope.
	visPrivate	("private "),
	** Internal scope.
	visInternal	("internal "),
	** Protected scope.
	visProtected("protected "),
	** Public scope.
	visPublic	("");
	
	** The keyword to be used in Fantom source code. 
	const Str keyword
	
	private new make(Str keyword) {
		this.keyword = keyword
	}

	** Returns the visibility of the given field / method.
	static PlasticVisibility fromSlot(Slot slot) {
		if (slot.isPrivate)
			return visPrivate
		if (slot.isInternal)
			return visInternal
		if (slot.isProtected)
			return visProtected
		if (slot.isPublic)
			return visPublic
		throw Err("What visibility is ${slot.signature}???")
	}
}